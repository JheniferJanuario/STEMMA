using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.DTOs.Responses;
using STEMMA.Application.Cadastro.Tutores.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.Tutores.UseCases;

public class UpdateTutorUseCase
{
    private readonly ITutorRepository _tutorRepository;

    public UpdateTutorUseCase(
        ITutorRepository tutorRepository)
    {
        _tutorRepository = tutorRepository;
    }

    public async Task<TutorResponse> ExecuteAsync(
        Guid id,
        UpdateTutorRequest request)
    {
        var tutor = await _tutorRepository.ObterPorIdAsync(id);

        if (tutor is null)
            throw new Exception("Tutor não encontrado.");

        TutorMapper.UpdateEntity(tutor, request);

        await _tutorRepository.AtualizarAsync(tutor);

        return TutorMapper.ToResponse(tutor);
    }
}