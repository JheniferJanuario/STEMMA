using STEMMA.Application.Consultas.DTOs.Responses;
using STEMMA.Application.Consultas.Mappers;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.UseCases;

public class ListConsultationsByPetUseCase
{
    private readonly IConsultaRepository _consultaRepository;

    public ListConsultationsByPetUseCase(
        IConsultaRepository consultaRepository)
    {
        _consultaRepository = consultaRepository;
    }

    public async Task<List<ConsultationResponse>> ExecuteAsync(
        Guid petId)
    {
        var consultas =
            await _consultaRepository.ObterPorPetAsync(petId);

        return ConsultaMapper.ParaListaResposta(consultas);
    }
}