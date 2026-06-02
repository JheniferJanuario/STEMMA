using STEMMA.Application.Consultas.Disponibilidades.DTOs.Requests;
using STEMMA.Domain.Consultas.Entities;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.Disponibilidades.UseCases;

public class CreateDisponibilidadeUseCase
{
    private readonly IDisponibilidadeRepository _repository;

    public CreateDisponibilidadeUseCase(
        IDisponibilidadeRepository repository)
    {
        _repository = repository;
    }

    public async Task<Guid> ExecuteAsync(
        CreateDisponibilidadeRequest request)
    {
        var existeConflito =
            await _repository.ExisteConflitoAsync(
                request.VeterinarioId,
                request.DataInicio,
                request.DataFim);

        if (existeConflito)
            throw new Exception(
                "Já existe disponibilidade cadastrada neste período.");

        var disponibilidade = new Disponibilidade(
            request.VeterinarioId,
            request.DataInicio,
            request.DataFim);

        await _repository.AdicionarAsync(disponibilidade);

        return disponibilidade.Id;
    }
}